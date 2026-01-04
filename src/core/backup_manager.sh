#!/bin/bash
# ==============================================================================
# AURORA - Módulo Backup Manager
# Gerencia backup de arquivos antes de modificações
# ==============================================================================

# Criar diretório de backups
ensure_backup_dir() {
	mkdir -p "$BACKUP_DIR"
}

# Backup de arquivo específico
backup_file() {
	local file="$1"

	if [[ ! -f "$file" ]]; then
		return 0
	fi

	ensure_backup_dir

	local filename
	filename=$(basename "$file")

	local timestamp
	timestamp=$(date +%Y%m%d_%H%M%S)

	local backup_file="$BACKUP_DIR/${filename}.${timestamp}.bak"

	cp "$file" "$backup_file"

	echo "Backup criado: $backup_file"

	# Limpar backups antigos
	cleanup_old_backups

	return 0
}

# Limpar backups antigos (manter apenas 10 mais recentes)
cleanup_old_backups() {
	if [[ ! -d "$BACKUP_DIR" ]]; then
		return 0
	fi

	# Contar backups por arquivo original
	local files
	files=$(ls -1 "$BACKUP_DIR"/*.bak 2>/dev/null | sed 's/\.[0-9]*\.[0-9]*_.*\.bak$//' | sort -u)

	for file in $files; do
		local backups
		backups=$(ls -1t "$BACKUP_DIR"/${file}.*.bak 2>/dev/null)

		local count
		count=$(echo "$backups" | wc -l)

		if ((count > 10)); then
			# Remover backups mais antigos que os 10 mais recentes
			echo "$backups" | tail -n +11 | xargs rm -f 2>/dev/null
		fi
	done
}

# Listar backups disponíveis
list_backups() {
	if [[ ! -d "$BACKUP_DIR" ]]; then
		echo "Nenhum backup encontrado"
		return 0
	fi

	echo "📦 Backups disponíveis:"
	echo ""

	ls -lt "$BACKUP_DIR"/*.bak 2>/dev/null | while read -r line; do
		local filename timestamp size
		filename=$(echo "$line" | awk '{print $NF}')
		timestamp=$(echo "$line" | awk '{print $6, $7, $8}')
		size=$(echo "$line" | awk '{print $5}')

		echo "  📄 $filename"
		echo "     📅 $timestamp  📏 $size"
		echo ""
	done

	return 0
}

# Restaurar backup
restore_backup() {
	local backup_file="$1"
	local target_file="$2"

	if [[ ! -f "$backup_file" ]]; then
		echo "Erro: Backup não encontrado: $backup_file"
		return 1
	fi

	# Backup do arquivo atual antes de restaurar
	if [[ -f "$target_file" ]]; then
		backup_file "$target_file"
	fi

	# Restaurar
	cp "$backup_file" "$target_file"

	echo "Backup restaurado: $backup_file → $target_file"

	return 0
}

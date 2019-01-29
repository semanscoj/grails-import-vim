let s:root = '~/projects/citygusto' 
let s:top = 'com'

augroup grailsImport
	autocmd!

	function! GetClassPath()
		let word = expand('<cWORD>')
		let pattern = 'class\s+' . word . '\b'
		return system('! ag -l "' . pattern . '" ' . s:root)
	endfunction

	function! RemoveExt(path)
		return substitute(a:path, '.groovy',  '', '')
	endfunction

	function! FindImportPathRoot(path)
		let index = 0
		let a = split(a:path, '/')
		for i in a
			if i == s:top
				break
			else
				let index += 1
			endif
		endfor
		return join(a[index:], '.')
	endfunction

	function! GetImportString()
		let result = GetClassPath()
		if len(result)
			return 'import ' . RemoveExt(FindImportPathRoot(result))
		else
			return 0
		endif
	endfunction

	function! AppendUnique(row)
		let pattern = escape(substitute(a:row, '\n', '', ''), '.')
		if search(pattern, 'n') > 0
			return 0
		else
			:call append(2, split(a:row, "\n"))
			return 1
		endif
	endfunction

	function! GrailsImport()
		let path = GetImportString()
		if len(path) > 1
			let success = AppendUnique(path)
			if success
				:echo 'x'
			else
				:echo 'y'
			endif
		else
			:echo 'Import not found'
		endif
	endfunction
augroup END

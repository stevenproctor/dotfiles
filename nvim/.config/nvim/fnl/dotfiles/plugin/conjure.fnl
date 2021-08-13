(module dotfiles.plugin.conjure
  {autoload {nvim aniseed.nvim}})

; (set nvim.g.conjure#eval#result_register "*")
; (set nvim.g.conjure#log#botright true)
; (set nvim.g.conjure#mapping#doc_word "gk")
(set nvim.g.conjure#extract#tree_sitter#enabled true)

; (n

; 
; 
;   au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#conjure#get_source_options({
;     \ 'name': 'conjure',
;     \ 'allowlist': ['clojure', 'fennel'],
;     \ 'triggers': {'*': ['/']},
;     \ 'time': 20,
;     \ 'completor': function('asyncomplete#sources#conjure#completor'),
;     \ }))

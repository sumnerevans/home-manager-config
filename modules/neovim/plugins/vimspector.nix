{ config, pkgs, ... }: {
  programs.neovim = {
    extraPackages = with pkgs; [
      go
      mono
      dotnet-runtime
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = vimspector;
        config = ''
          let g:vimspector_base_dir=expand( '${config.xdg.dataHome}/nvim/vimspector' )
          let g:vimspector_install_gadgets = [
            \ 'CodeLLDB',
            \ 'debugpy',
            \ 'delve',
            \ 'netcoredebug',
            \ 'vscode-cpptools',
            \ 'vscode-java-debug',
            \ ]

          " This is basically the same as the Visual Studio mappings given by
          " vimspector, but without the VimspectorPause binding on F6 (which is
          " reserved for coc-rename)
          nmap <F5>         <Plug>VimspectorContinue
          nmap <S-F5>       <Plug>VimspectorStop
          nmap <C-S-F5>     <Plug>VimspectorRestart
          " nmap <F6>         <Plug>VimspectorPause
          nmap <F9>         <Plug>VimspectorToggleBreakpoint
          nmap <S-F9>       <Plug>VimspectorAddFunctionBreakpoint
          nmap <F10>        <Plug>VimspectorStepOver
          nmap <F11>        <Plug>VimspectorStepInto
          nmap <S-F11>      <Plug>VimspectorStepOut
        '';
      }
    ];
  };
}

{ config, ... }:
let
  home = config.home.homeDirectory;
  doc = "${config.home.homeDirectory}/Documents";
  proj = "${config.home.homeDirectory}/projects";
in
{
  programs.zsh.dirHashes = {
    df = "${home}/.local/share/chezmoi";
    dl = "${home}/Downloads";
    pass = "${home}/.password-store";
    pics = "${home}/Pictures";
    st = "${home}/Syncthing";
    scratch = "${home}/scratch";
    tmp = "${home}/tmp";
    vid = "${home}/Videos";

    # Documents
    doc = doc;
    ch = "${doc}/cheatsheets";
    no = "${doc}/notes";
    pres = "${doc}/presentations";

    # Teaching
    sch = "${home}/school";
    tea = "${home}/school/teaching";
    aca = "${home}/school/teaching/aca";

    # Projects
    proj = proj;
    aoc = "${proj}/advent-of-code";
    hspc = "${proj}/acm/hspc-problems";
    infra = "${proj}/infrastructure";
    kattis = "${home}/projects/kattis";
    res = "${proj}/resume";
    sub = "${proj}/sublime-music/sublime-music";
    sws = "${proj}/sumnerevans.com";
    tt = "${proj}/tracktime";
    vis = "${proj}/acm/visplay";
    yt = "${proj}/youtube-content";
  };
}

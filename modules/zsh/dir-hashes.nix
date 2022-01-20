{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  programs.zsh.dirHashes = rec {
    dl = "${home}/Downloads";
    pass = "${home}/.local/share/password-store";
    pics = "${home}/Pictures";
    st = "${home}/Syncthing";
    scratch = "${home}/scratch";
    tmp = "${home}/tmp";
    vid = "${home}/Videos";

    # Documents
    doc = "${home}/Documents";
    ch = "${doc}/cheatsheets";
    no = "${doc}/notes";
    pres = "${doc}/presentations";

    # Teaching
    sch = "${home}/school";
    tea = "${sch}/teaching";
    algo = "${tea}/algos22";
    aca = "${tea}/aca";
    ppl = "${tea}/pplf21";

    # NixOS config
    cfg = "/etc/nixos";

    # Projects
    proj = "${home}/projects";
    aoc = "${proj}/advent-of-code";
    hm = "${proj}/home-manager";
    hspc = "${proj}/acm/hspc-problems";
    kattis = "${home}/projects/kattis";
    res = "${proj}/resume";
    sub = "${proj}/sublime-music/sublime-music";
    sws = "${proj}/sumnerevans.com";
    tt = "${proj}/tracktime";
    yt = "${proj}/youtube-content";
  };
}

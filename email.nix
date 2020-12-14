{ ... }: {
  # TODO look into astroid
  accounts.email.accounts = {
    Personal = {
      address = "me@sumnerevans.com";
      aliases = [ "alerts@sumnerevans.com" "resume@sumnerevans.com" ];
      primary = true;
    };

    Gmail = {
      address = "sumner.evans98@gmail.com";
      flavor = "gmail.com";
    };

    Mines = {
      address = "jonathanevans@mymail.mines.edu";
      flavor = "gmail.com";
    };

    Admin = {
      address = "admin@sumnerevans.com";
      aliases = [ "abuse@sumnerevans.com" "hostmaster@sumnerevans.com" "postmaster@sumnerevans.com" ];
    };

    Comments = {
      address = "comments@sumnerevans.com";
    };

    Inquiries = {
      address = "inquiries@sumnerevans.com";
    };

    Junk = {
      address = "junk@sumnerevans.com";
    };
  };
}

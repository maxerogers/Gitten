#Seed.rb
User.create(user_name: 'yvds', email: 'yvonne@yvds.net', website: 'http://www.yvds.net',
      password: 'catgod', password_confirmation: 'catgod', name: 'Yves DeSousa')
User.create(user_name: 'honeycoded', email: 'maxrogers90@gmail.com', website: 'http://www.merogers.me',
      password: 'max', password_confirmation: 'max', name: 'Max Rogers')
Repo.create(title: "Gitten",date_location: "HackRU Fall 2014", demo_link: "http://murmuring-ocean-1449.herokuapp.com/home",
            repo_link:"https://github.com/honeycodedbear/Gitten", blurb: "I am the best hack here at the HackRU",
            user: User.last)
Following.create(r: Repo.last, u: User.first)
Repo.create(title: "Catter",date_location: "Oct 2014", demo_link: "",
            repo_link:"https://github.com/honeycodedbear/catter", blurb: "After helping my friend Eve with her new rails project I noticed my rails skills have gotten rusty so I decided to remake twitter with a cat theme. ",
            user: User.last)
Repo.create(title: "Gitter",date_location: "Unhackathon 2014", demo_link: "",
            repo_link:"https://github.com/honeycodedbear/gitter", blurb: "Register a repo and harass your friends on twitter ",
            user: User.last)

Repo.create(title: "Bibliotecha",date_location: "Oct 2014", demo_link: "",
            repo_link:"https://github.com/yvds/bibliotecha", blurb: "disregard jee, acquire gems",
            user: User.first)


Repo.create(title: "PremiumCatFacts",date_location: "Oct 2014", demo_link: "",
            repo_link:"https://github.com/yvds/PremiumCatFacts", blurb: "#praisecatgod #praisecatgod #praisecatgod #praisecatgod #praisecatgod
",
            user: User.first)
Following.create(r: Repo.last, u: User.last)

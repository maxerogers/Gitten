#Seed.rb
User.create(user_name: 'yvds', email: 'yvonne@yvds.net', website: 'http://www.yvds.net',
      password: 'catgod', password_confirmation: 'catgod', name: 'Yves DeSousa')
User.create(user_name: 'honeycoded', email: 'maxrogers90@gmail.com', website: 'http://www.merogers.me',
      password: 'max', password_confirmation: 'max', name: 'Max Rogers')
Repo.create(title: "Gitten",date_location: "HackRU Fall 2014", demo_link: "http://murmuring-ocean-1449.herokuapp.com/home",
            repo_link:"https://github.com/honeycodedbear/Gitten", blurb: "I am the best hack here at the HackRU",
            user: User.last)

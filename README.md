# ProjectFIREBALL
File Information Repository, Exposing Beneficial Analysis &amp; Logical Lore

[![Build Status](https://travis-ci.org/davidyoung604/ProjectFIREBALL.svg?branch=master)](https://travis-ci.org/davidyoung604/ProjectFIREBALL)
[![Code Climate](https://codeclimate.com/github/davidyoung604/ProjectFIREBALL/badges/gpa.svg)](https://codeclimate.com/github/davidyoung604/ProjectFIREBALL)
[![Dependency Status](https://gemnasium.com/badges/github.com/davidyoung604/ProjectFIREBALL.svg)](https://gemnasium.com/github.com/davidyoung604/ProjectFIREBALL)

#### Running
The simplest way to deploy the app is via Docker:

```bash
docker run -d -p <your port>:8080 -v <your volume config> davidyoung604/fireball
```

Alternatively, you can deploy the app yourself:

```bash
git clone https://github.com/davidyoung604/ProjectFIREBALL.git
cd ProjectFIREBALL
export RAILS_ENV=production
export SECRET_KEY_BASE=$(rails secret)
export RAILS_SERVE_STATIC_FILES=true
bundle install
rails db:setup
rails assets:precompile
unicorn -l 0.0.0.0:8080
```

#### Benchmarking
Get yourself into the rails console: `rails console`

Run the benchmarks:
```bash
load 'test/benchmarking/XYZ.rb'

# Or to run them all (because you're curious what sort of improvements there have been)
Dir.glob('test/benchmarking/*.rb').each { |f| load(f) }
```

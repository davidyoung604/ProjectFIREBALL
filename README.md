# ProjectFIREBALL
File Information Repository, Exposing Beneficial Analysis &amp; Logical Lore

[![Build Status](https://travis-ci.org/davidyoung604/ProjectFIREBALL.svg?branch=master)](https://travis-ci.org/davidyoung604/ProjectFIREBALL)
[![Test Coverage](https://codeclimate.com/github/davidyoung604/ProjectFIREBALL/badges/coverage.svg)](https://codeclimate.com/github/davidyoung604/ProjectFIREBALL/coverage)
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

#### Getting Started
The default credentials are Admin/admin.

After logging in, you'll find that the root page is somewhat useless to you. That's because no files have been indexed yet and you'll need to index at least one directory.

0. Start by clicking "Directories" on the menu bar at the top of the page.
0. Next, click "Index a new directory".
0. Enter the **full path** into the textbox (e.g. `/home/myusername/gopro_videos`) and click "Index".
0. Within a few seconds, the system will start working in the background to scan your chosen directory, and results will start showing up on the main page. Click "ProjectFIREBALL" on the menu bar to return to the main page and see some live statistical information.

#### Using Project FIREBALL
Searches can be conducted from the main page - simply use the search bar as you would use any other. The difference, however, is that each new word that's added will expand the number of results, rather than creating a more precise search. This was done for the sake of simplicity. I plan to address this in the future.

Also on the main page are the system statistics. These include total disk usage of all indexed files and disk usage by category, among others. While some users may dismiss such information as superfluous, users such as myself find it relevant and informative.

As my file collection grows on each machine, I need to know how much space I'm using and what that space has been allocated for. Indexing my laptop's `Desktop` folder, for example, revealed that I have approximately 60 GB of GoPro videos stored there. As my laptop is no longer my primary video editing system, it would make more sense for me to transfer these files to the other system, which has far greater hard drive capacity than my laptop. Had I not reviewed the "10 Largest Files" chart, I would not have realized how much space my GoPro videos were taking up.

Creating and modifying categories can only be performed by admin users. Creating a new category with a set of file extensions will also update the mappings. Please note, however, that an extension can only belong to one category at a time, and setting it on one category will remove it from any category it may have previously been a part of.

Also note that the 'Unsorted' category is a special case and cannot be directly modified, as its purpose is to gather any files that do not currently fit in a category.

Tags are the primary means to organize files in Project FIREBALL. Each file can have as many tags as the user wishes, and viewing a specific tag will show the user all the files that match that tag.

Setting tags can be done in one of two ways: first, by editing a single file and applying tags to it directly, and second, by editing a directory and setting tags to be applied to each of that directory's files. As directories are an aggregation object in the system, they do not have tags themselves. When applying tags to multiple files at once by going through the directory, the user is also able to "cascade" the changes to any child directories as well. This is particularly useful for deep folder hierarchies, where the user may not want to iterate through N layers of folders to apply the same set of tags. Note that in either case, tags do not need to be explicitly created before they can be applied. Simply entering a previously unused string as one of the CSV values will automatically create the tag record and set up all necessary mappings.

#### Benchmarking
Get yourself into the rails console: `rails console`

Run the benchmarks:
```bash
load 'test/benchmarking/XYZ.rb'

# Or to run them all (because you're curious what sort of improvements there have been)
Dir.glob('test/benchmarking/*.rb').each { |f| load(f) }
```

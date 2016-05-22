# RunbyPace

RunbyPace contains the core logic for calculating the target "paces" used by runners. By "runners" I mean  the common
 humanoid biped variety, complete with oscillating appendages and prolific perspiration. :)

| | |
| --- | --- |
| **Build** | [![Build Status](https://travis-ci.org/tygerbytes/runby-pace.svg?branch=master)](https://travis-ci.org/tygerbytes/runby-pace) |
| **Coverage** | [![Coverage Status](https://coveralls.io/repos/github/tygerbytes/runby-pace/badge.svg?branch=master)](https://coveralls.io/github/tygerbytes/runby-pace?branch=master) |

Any sort of running program will include runs at varying paces, easy runs, distance runs, tempo runs, long runs, and
 then the gambit of "interval" type runs, such as 1500m pace repetitions, 5K and 10K pace reps, cruise intervals, and
 so on. Many runners typically consult pace tables based on their most recent time for a 5K race. So assuming your most
 recent 5K time was 20 minutes, and you're supposed to run a "long run", you find your most recent 5K time in the
 Long Run table, and it tells you that you should try to maintain a pace of 5:30-6:19 minutes per kilometer.

So this is great, but a little tedious. RunbyPace automates this whole process by calculating all of the paces for you.
 All you need is your current 5K time and some Ruby, and you're off running at just the right pace.

Note that this project is currently being developed, so the gem doesn't even exist yet. Coming soon!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'runby_pace'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install runby_pace

## Usage

TODO: Coming soon... When the class interfaces are fleshed out.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tygerbytes/runby-pace.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

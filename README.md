# NewsBotIRC Salt Formula
Salt formula to run NewsBotIRC on a Docker container

## Requirements

- Salt
- Docker
- Docker client in Python
- Git client

## Installation instructions

1. Copy the contents of this repo to /srv/salt
2. Move /srv/salt/pillar.example to /srv/pillar/newsbot.sls
3. Edit values in /srv/pillar/newsbot.sls
4. Add the pillar file to the top.sls file in /srv/pillar/top.sls. Example of */srv/pillar/top.sls*:
```
    base:
        'your_target':
            - newsbot
```
5. Refresh the pillar with `salt 'your_target' saltutil.pillar_refresh`
6. Run the state with `salt 'your_target' state.sls newsbot`

Note: replace *yourtarget* with the minion ID where the bot will run.

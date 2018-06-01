download_newsbot:
    git.latest:
        - name: https://github.com/MadCoderZ/NewsBotIRC
        - rev: master
        - target: {{ salt['pillar.get']('newsbot:directory', '/tmp/newsbot') }}

copy_properties_file:
    file.managed:
        - name: {{ salt['pillar.get']('newsbot:directory', '/tmp/newsbot') }}/src/main/resources/newsbot.properties
        - source: salt://newsbot/newsbot.properties
        - onchanges:
            - git: download_newsbot

remove_bot_container:
    docker_container.absent:
        - name: newsbot
        - force: True
        - onchanges:
            - git: download_newsbot

remove_bot_image:
    docker_image.absent:
        - name: newsbot
        - require:
            - docker_container: remove_bot_container
        - onchanges:
            - git: download_newsbot

build_bot:
    docker_image.present: 
        - name: newsbot
        - build: {{ salt['pillar.get']('newsbot:directory', '/tmp/newsbot') }}
        - tag: latest
        - onchanges:
            - git: download_newsbot

notify_on_build_fail:
    event.send:
        - name: madcoderz/newsbot/build/failed
        - onfail:
            - docker_image: build_bot

run_bot_container:
    docker_container.run:
        - name: newsbot
        - image: newsbot:latest
        - bg: True
        - require:
            - docker_image: build_bot
        - onchanges:
            - git: download_newsbot


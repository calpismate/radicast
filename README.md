# radicast

![Workflow main.yml](https://github.com/calpismate/radicast/actions/workflows/main.yml/badge.svg)

* Record Radiko
* Serve RSS for Podcast

## Requirements

* rtmpdump
* swftools
* ffmpeg or avconv
* or docker (see docker section)

## Install

```
$ git clone https://github.com/calpismate/radicast
```

## Usage

### Setup config.json

```
$ docker-compose run --entrypoint "/app/radicast" radicast --setup | grep -Ev '^[0-9]{4}/.*' > config.json
```

### Edit config.json

```
$ vim config.json
$ cat config.json

{
  "FMT": [
    "0 0 17 * * *"
  ]
}
```

Cron specification is [here](https://godoc.org/github.com/robfig/cron#hdr-CRON_Expression_Format)

### Launch

```
$ docker-compose up -d
$ curl 127.0.0.1:3355/rss # podcast rss
```

### Reload config.json

Radicast will reload config when receive HUP signal.

## See also

* [miyagawa/ripdiko](https://github.com/miyagawa/ripdiko)
* [kojisano/radicast](https://github.com/kojisano/radicast)
* [omiso46/radcast](https://github.com/omiso46/radcast)

## License

* MIT License

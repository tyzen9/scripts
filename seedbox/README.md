# scripts

## Requirements:
lftp 
```
sudo apt install lftp
```

## Configuration

1. Create a `config.sh` file from `config_sample.sh
2. Create a `${HOME}/.lftp/rc` file from `rc_sample`
3. Test
4. Create a cron job to run on every 5th minute.

```
*/5 * * * * /home/stheisen/scripts/seedbox/seedboxSync.sh
```
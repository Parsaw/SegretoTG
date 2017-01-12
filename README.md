# SegretoTG
<h1><p align="center"> Editor : [Pяƨw ѕн∆rr](https://telegram.me/PrswShrr)
<h1><p align="center"> `Version 2`
***
<h1><p align="center"> [کانال|Channel](https://telegram.me/Segreto_Ch)
<h1><p align="center"> [پشتیبانی|Support](https://telegram.me/joinchat/AAAAAEEsb5Gu9DD9NwncIQ)
***

- [x] کار با دیتا
- [x] پرسرعت 
- [x] دارای قفل های کاربردی 
- [x] دستورات ساده
- [x] تنها دارای 4 پلاگین
- [x] دارای کمترین باگ ممکن
- [x] کمترین زمان آفلاینی


***
## دستورات نصب
```sh
sudo apt-get update

sudo apt-get upgrade

sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev

cd $HOME

wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
 tar zxpf luarocks-2.2.2.tar.gz
 cd luarocks-2.2.2
 ./configure; sudo make bootstrap
 sudo luarocks install luasocket
 sudo luarocks install luasec
 sudo luarocks install redis-lua
 sudo luarocks install lua-term
 sudo luarocks install serpent
 sudo luarocks install dkjson
 sudo luarocks install lanes
 sudo luarocks install Lua-cURL

cd ..

git clone https://github.com/Parsaw/SegretoTG.git

cd SegretoTG

chmod +x launch.sh

git clone --recursive https://github.com/janlou/tg.git && cd tg && ./configure && make && cd ..

./launsh.sh
```
***
## فعال سازی راه اندازی سـگـرتو
```sh

cd $HOME

cd SegretoTG

chmod 777 segreto.sh

screen ./segreto.sh
```
***
## فعال سازی بدون آنتی کرش
```sh 
cd $HOME

cd SegretoTG

screen ./launch.sh
```
***
بعد از اولین لانچ وارد پوشه دیتا شده و ایدی عددی خود را در قسمت سودو ها وارد نمایید و مجددا ربات را لانچ کنید.
***


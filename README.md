# **Furigana Lyrics Maker**

Are you are a japanese learner like me, and you like to sing anime songs with wrong accents and pronunciation while you cook, do the laundry and drive?
Aren't you tired of manually mixing and matching the japanese and translated texts to follow the score more easily, just to be abused by kanji you don't know anyway?

Well fear no more fellow kanji hater! Furigana Lyrics Maker has you covered!
A free and open source tool written in flutter to create japanese lyrics with translations and furigana, hosted at [https://lyrics.sielotech.com](https://lyrics.sielotech.com)!

Defeat those nasty kanji in the blink of an eye! Insert the japanese lyrics, the translated lyrics in the language you like, and they will be automagically mixed line by line, with free-as-in-free-beer juicy furigana included!

Of course, you are more than welcome to use the tool just to add furigana to a piece of text, I use it that way myself a lot of times!

## I hate GUIs
You would love to use this tool but you can't absolutely stand graphical interfaces, in fact you are reading this with w3m on a custom linux distro you implemented from scratch using vi? I will soon release lyrics-maker-stoneage-edition, just for you! It's a CLI tool and works even offline as a bonus! It's the backbone powering this project, without all the bells and whistles.

## Known problems
- I'm trying wrapping my head around MeCab, the C library that analyzes the japanese input. I still don't completely understand how it works, so you will probably encounter some wrong furigana every now and then, plus some useless furigana above text already in hiragana or katakana. I will try to address this problems as soon as possible! This tool is still in beta stage!

- I didn't extensively test the tool on every possible screen size, browser and OS, but it is technically optimized with different custom layouts for small and big screens. If you think what you are seeing doesn't make any sense, please let me know! I will gladly try to fix the problem!

- The code could certainly be improved a lot! I started using Flutter not so long ago and I'm still learning a lot of basic things. Please don't copy my code if you are a spaceship engineer or something >.<

- Probably something I don't know yet.

## FAQ
**Why are the lyrics only exported as HTML?**
Sadly ruby text (furigana) is supported on a very small number of programs and formats by default. HTML is the simplest way to display furigana correctly with a program that anyone has installed (your browser). You are free to copy-paste the text from the HTML document to your favourite program/tool and see how it goes (but sadly it will probably go really bad.) I'm open to suggestions though! The next export formats I plan to add are:
1. PDF - It should technically be capable of showing a rendered HTML file without problems;
2. TXT - It can't display furigana above kanji because it's plain text, but it will be universally usable, because furigana will be normal text inside parenthesis like so:
日本語 (にほんご).

**Were you drunk while writing the initial description?**
:(

## Data collection (read with a serious voice now)
The website itself is hosted on Firebase Hosting.
The actual conversion to furigana happens through an endpoint at api.sielotech.com, also mantained by me, which runs on a Google Compute Engine.

While I don't intentionally collect or store any of the data inputted in the website or sent to the endpoint, I cannot guarantee that Google or other companies don't log any data somewhere, so please don't input any sensitive data if you (like me) care about that.

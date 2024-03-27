#!/bin/bash

echo -n "[ ] Which PHP version should be installed? (Default: php8.2) "
read phpversion

if [ -z "$phpversion" ]; then 
    phpversion="php8.2" 
fi

echo "$phpversion"
if [[ ! "$phpversion" =~ [0-9]  ]]; then 
    echo "PHP version incorrectly formatted"
    exit 0
elif [[ ! "$phpversion" =~ "^php" ]] && [[ "$phpversion" =~ [0-9]  ]]; then
    phpversion="php$phpversion"
fi

# atualiza o sistema
sudo apt update -y && sudo apt upgrade -y

# verifica se o php ja esta instalado
phpinstalado=$($phpversion --version 2>/dev/null | grep PHP)
if [ -z "$phpinstalado" ]; then
    #adiciona ppa e instala o php
    echo "Adding ppa:ondrj/php"
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update -y && sudo apt install $phpversion -y
fi

# instala extensoes php
sudo apt install $phpversion-curl -y
sudo apt install $phpversion-simplexml -y
sudo apt install $phpversion-dom -y
sudo apt install $phpversion-intl -y
sudo apt install $phpversion-gd -y
sudo apt install $phpversion-mysql -y
sudo apt install $phpversion-zip -y
sudo apt install $phpversion-mbstring -y


# verifica se o composer ja esta instalado
composerinstalado=$(composer --version 2>/dev/null | grep version)
if [ -z "$composerinstalado" ]; then
    #instala o composer
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
fi

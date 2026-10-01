# Maintainer: Barbel <barbel@barbel.org>
pkgname=barbelos-shell-defaults
pkgver=1.0
pkgrel=1
pkgdesc="BarbelOS default shell (zsh, starship and fastfetch) configuration"
arch=('any')
license=('AGPL-3.0-or-later')
url='https://github.com/BarbelDotOrg/barbelos-shell-config'
depends=('zsh' 'starship' 'fastfetch' 'fzf' 'eza' 'bat' 'zoxide'
         'zsh-completions'
         'zsh-autosuggestions'
         'zsh-syntax-highlighting'
         'zsh-history-substring-search'
         'fzf-tab'
         'zsh-autopair-git'
         'ttf-jetbrains-mono-nerd')
optdepends=('fd: faster file search for fzf'
            'tldr: "help" alias'
            'btop: "top" alias'
            'neovim: "vim" alias'
            'git: git aliases')
backup=('etc/zsh/zshrc'
        'etc/starship.toml'
        'etc/xdg/fastfetch/config.jsonc')
source=('zshrc' 'starship.toml' 'fastfetch.jsonc' 'logo.txt' 'opsec-level.sh')
sha256sums=('34fdbb5d78e3496f948f2c2e4bada40b7646245670d275ede4a8a0db3632687a'
            'f0c10387cfe38fa96d9d532540d111a4f5986dbd47528e12ac1e8916972d6a53'
            '6fbd39c40c171d6a94be713350268422e5628cc7a7223d1074095122168dee6e'
            '6e98a07d5b3fa15b66bcae26ccc4d1e1c1cc40945679d12b347d7247b8e831a0'
            'ef3fd31019dfe8a53c4d8c662ed5611e655af01bb57b3290e6658137ffd8acb6')

package() {
  install -Dm644 zshrc           "$pkgdir/etc/zsh/zshrc"
  install -Dm644 starship.toml   "$pkgdir/etc/starship.toml"
  install -Dm644 fastfetch.jsonc "$pkgdir/etc/xdg/fastfetch/config.jsonc"
  install -Dm644 logo.txt        "$pkgdir/usr/share/barbelos/logo.txt"
  install -Dm755 opsec-level.sh "$pkgdir/usr/bin/opsec-level"
}

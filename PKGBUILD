# Maintainer: Barbel <barbel@barbel.org>
pkgname=barbelos-shell-defaults
pkgver=1.0
pkgrel=1
pkgdesc="BarbelOS default shell (zsh, starship and fastfetch) configuration"
arch=('any')
license=('AGPLv3')
depends=('zsh' 'starship' 'fastfetch' 'fzf' 'eza' 'bat' 'zoxide'
         'zsh-autosuggestions' 'zsh-syntax-highlighting')
backup=('etc/zsh/zshrc'
        'etc/starship.toml'
        'etc/xdg/fastfetch/config.jsonc')
source=('zshrc' 'starship.toml' 'fastfetch.jsonc' 'logo.txt' 'opsec-level.sh')
sha256sums=('10a3b1a6f8fa049eb72a46776ff480bf974a7ec480ab6224b2948eb6c408a087'
            'f0c10387cfe38fa96d9d532540d111a4f5986dbd47528e12ac1e8916972d6a53'
            '758ff36eb25c358b8aba0a6468f628c3808edb737ebf3d8ffc5c62a2bf9d8e64'
            '6e98a07d5b3fa15b66bcae26ccc4d1e1c1cc40945679d12b347d7247b8e831a0'
            'b3895008cb569b5118bd6d1d4315bdab2a595e1726b6ffe95b793d0eb4aae594')

package() {
  install -Dm644 zshrc           "$pkgdir/etc/zsh/zshrc"
  install -Dm644 starship.toml   "$pkgdir/etc/starship.toml"
  install -Dm644 fastfetch.jsonc "$pkgdir/etc/xdg/fastfetch/config.jsonc"
  install -Dm644 logo.txt        "$pkgdir/usr/share/barbelos/logo.txt"
  install -Dm755 opsec-level.sh "$pkgdir/usr/bin/opsec-level"
}

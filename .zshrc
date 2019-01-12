if [[ -f $HOME/.zplug/init.zsh ]]; then
  setopt nonomatch

  export PATH="$HOME/.rbenv/bin:$PATH" 
  eval "$(rbenv init - zsh)"

  source ~/.zplug/init.zsh
  
  zplug "zplug/zplug"

  zplug "chrissicool/zsh-256color"
  zplug "hchbaw/auto-fu.zsh"

  # ダブルクォーテーションで囲うと良い
  zplug "zsh-users/zsh-history-substring-search"

  # コマンドも管理する
  # グロブを受け付ける（ブレースやワイルドカードなど）
  zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"

  # こんな使い方もある（他人の zshrc）
  zplug "tcnksm/docker-alias", use:zshrc

  # frozen タグが設定されているとアップデートされない
  zplug "k4rthik/git-cal", as:command, frozen:1

  # GitHub Releases からインストールする
  # また、コマンドは rename-to でリネームできる
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"*darwin*amd64*"

  # oh-my-zsh をサービスと見なして、
  # そこからインストールする
  #zplug "plugins/git",   from:oh-my-zsh

  # if タグが true のときのみインストールされる
  #zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

  # prezto のプラグインやテーマを使用する
  #zplug "modules/osx", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"
  #zplug "modules/prompt", from:prezto
  # zstyle は zplug load の前に設定する
  zstyle ':prezto:module:prompt' theme 'sorin'

  # インストール・アップデート後に実行されるフック
  # この場合は以下のような設定が別途必要
  # ZPLUG_SUDO_PASSWORD="********"
  zplug "jhawthorn/fzy", \
    as:command, \
    rename-to:fzy, \
    hook-build:"make && sudo make install"

  # リビジョンロック機能を持つ
  zplug "b4b4r07/enhancd", at:v1
  zplug "mollifier/anyframe", at:4c23cb60

  # Gist ファイルもインストールできる
  zplug "b4b4r07/79ee61f7c140c63d2786", \
    from:gist, \
    as:command, \
    use:get_last_pane_path.sh

  # bitbucket も
  zplug "b4b4r07/hello_bitbucket", \
    from:bitbucket, \
    as:command, \
    use:"*.sh"

  # `use` タグでキャプチャした文字列でリネームする
  zplug "b4b4r07/httpstat", \
    as:command, \
    use:'(*).sh', \
    rename-to:'$1'

  # 依存管理
  # "emoji-cli" は "jq" があるときにのみ読み込まれる
  zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq
  zplug "b4b4r07/emoji-cli", \
    on:"stedolan/jq"
  # ノート: 読み込み順序を遅らせるなら defer タグを使いましょう

  # 読み込み順序を設定する
  # 例: "zsh-syntax-highlighting" は compinit の前に読み込まれる必要がある
  # （2 以上は compinit 後に読み込まれるようになる）
  zplug "zsh-users/zsh-syntax-highlighting", defer:2

  # ローカルプラグインも読み込める
  zplug "~/.zsh", from:local

  # テーマファイルを読み込む
  zplug 'dracula/zsh', as:theme

  # 未インストール項目をインストールする
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

  # コマンドをリンクして、PATH に追加し、プラグインは読み込む
  zplug load --verbose
  test -f ~/.moonline/moonline.zsh && source ~/.moonline/moonline.zsh && moonline initialize
fi
eval "$(rbenv init -)"
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}

tmux_automatically_attach_session

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
source /usr/share/nvm/init-nvm.sh

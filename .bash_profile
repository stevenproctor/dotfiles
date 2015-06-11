[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

[[ -f ~/.bashrc ]] && . ~/.bashrc

PATH=/usr/local/bin:~/bin:/usr/local/share/npm/bin:$PATH
PATH=$PATH:$HOME
set -o vi
export EDITOR='vim'

export CLICOLOR=1

if which brew 2>/dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# came from Aaron Lasseigne (AaronLasseigne on GitHub)
battery_status()
{
  HEART='♥ '

  NON='\[\e[0m\]'
  RED='\[\e[0;31m\]'

  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | cut -d ' ' -f 3)
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | cut -d ' ' -f 3)

  charged_slots=$(echo "(($current_charge/$total_charge)*10)+1" | bc -l | cut -d '.' -f 1)
  if [[ $charged_slots -gt 10 ]]; then
    charged_slots=10
  fi

  echo -n "${RED}"
  for i in `seq 1 $charged_slots`; do echo -n "$HEART"; done
  echo -n "${NON}"

  if [[ $charged_slots -lt 10 ]]; then
    for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$HEART"; done
  fi
}

export PROMPT_COMMAND='PS1="[\d \t] \h:\W \u\$ "'

source ~/.bash/aliases

if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR="/Users/sg0221754/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

"$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
PATH=/usr/local/bin:~/bin:/usr/local/share/npm/bin:$PATH
PATH=$PATH:$HOME
set -o vi

export CLICOLOR=1

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

PS1="$(battery_status) \h:\W \u\$ "


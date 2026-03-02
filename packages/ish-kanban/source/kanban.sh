#!/usr/bin/env bash

ish_kanban_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${ish_kanban_module_dir}/kanban/task.sh"
source "${ish_kanban_module_dir}/kanban/scratch.sh"
source "${ish_kanban_module_dir}/test.sh"

ish_kanban_show() {
  local ish_kanban_dir
  ish_kanban_dir="$(ish_packages_data_dir "ish-kanban")"

  ish_tui_template_file --path="${ish_kanban_dir}/board.md"
}

ish_kanban_help() {
  ish_stream_multiline_stderr <<EOF

                                                     .:.
                                           ....::oooOOO.
         :ooo::::::::::::::::::::ooooooooOOOOOOOOOOo:::
         ...oOOOOOOOOOOOOOOOOOOOOO8OOOOOOOOOOooooo.
             .ooooooOOOoooooO8888O:::..oOO:.
                    :OO.    .O888:     :OO:
              ::::::oOOo::::oO8OOooooooOoOooooooo:
              ::::::oOO:::::............oo.
                    :Oo                 oo
             ....   :Oo           .:o:.:oo.  ..
             .OO:   oO: :OO:       :Oo :oo: .oO:
             .Ooo:.:OOo.:OO.       oOo:oOoo..oo.
              oo:..oOOo.:OO        :Oo.oOOo:.oo.
              oo   :OO:  OO        .Oo :OOo. :O.
              oo   :OO:  OO        .Oo :OOO: :O.
             .OO:..oOOo::OO.       :Oo.oOOOo.oO:
             :OOoooO8OO::88.       oOOoO88OOoO8:
             .OO.  O88O .88        o8O..888o o8:
             .OO: .o88o .OO        o8O::888o o8:
             .OO.  :O8: .Oo        oOO:o88O: oO.
             .oo.  :OO: .o:        :Oo::O8O: .:.
             .o:  .oOO: .:.        :oo.:OOo. .o.
              ::. .:oo. .:.        .::.:oo:.  :.
             .:..  :OO:..:.       .:::.:oo:. .:.
            ..::..:ooo:.......... .:::::oo:. .:
            ..::..:o::..:....... ...:::oOO:.....
             ......::::...... ... ...:::oo:.....
                ..:::::.......... ..:::o:::....
            ..:.....::o:...... ......::oo:.....
             .::...::oo:...:........:...:::......

usage: ish kanban [command]

commands:
  show     output board.md
  task     manage tasks
  scratch  manage scratchpad
  test     run kanban tests
EOF
}

ish_kanban_route() {
  case "${1-}" in
    show)
      shift
      ish_kanban_show "$@"
      ;;
    task)
      shift
      case "${1-}" in
        list)
          shift
          ish_kanban_task_list "$@"
          ;;
        new)
          shift
          ish_kanban_task_new "$@"
          ;;
        delete)
          shift
          ish_kanban_task_delete "$@"
          ;;
        show)
          shift
          ish_kanban_task_show "$@"
          ;;
        path)
          shift
          ish_kanban_task_path "$@"
          ;;
        help|"")
          ish_kanban_task_help
          ;;
        *)
          ish_tui_error --message="unknown kanban task command: ${1-}"
          ;;
      esac
      ;;
    scratch)
      shift
      case "${1-}" in
        capture)
          shift
          ish_kanban_scratch_capture "$@"
          ;;
        show)
          shift
          ish_kanban_scratch_show "$@"
          ;;
        path)
          shift
          ish_kanban_scratch_path "$@"
          ;;
        help|"")
          ish_kanban_scratch_help
          ;;
        *)
          ish_tui_error --message="unknown kanban scratch command: ${1-}"
          ;;
      esac
      ;;
    test)
      shift
      ish_kanban_test_route "$@"
      ;;
    help|"")
      ish_kanban_help
      ;;
    *)
      ish_tui_error --message="unknown kanban command: ${1-}"
      ;;
  esac
}

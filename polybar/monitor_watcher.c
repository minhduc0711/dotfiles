/*
 * Compile with -lxcb -lxcb-randr
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <xcb/xcb.h>
#include <xcb/randr.h>

int main() {
  xcb_connection_t* conn;
  xcb_screen_t* screen;
  xcb_window_t window;
  xcb_generic_event_t* evt;
  xcb_randr_screen_change_notify_event_t* randr_evt;
  time_t t0 = 0;
  time_t t1;

  conn = xcb_connect(NULL, NULL);

  screen = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
  window = screen->root;
  xcb_randr_select_input(conn, window, XCB_RANDR_NOTIFY_MASK_SCREEN_CHANGE);
  xcb_flush(conn);

  while ((evt = xcb_wait_for_event(conn)) != NULL) {
    if (evt->response_type & XCB_RANDR_NOTIFY_MASK_SCREEN_CHANGE) {
      randr_evt = (xcb_randr_screen_change_notify_event_t*) evt;
      t1 = time(NULL);
      if (t1 - t0 > 2) {
        int pid = fork();
        if (pid == 0) {
          printf("you did it\n");
          char *name[] = {
            "/bin/bash",
            "-c",
            "~/.config/polybar/launch.sh; nitrogen --restore",
            NULL
          };
          execvp(name[0], name);
        }
      }
      t0 = t1;
    }
    free(evt);
  }
  xcb_disconnect(conn);
}
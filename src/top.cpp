#include "top.h"

top::top (sc_core::sc_module_name name, const char *renode_address,
          const char *renode_port)
    : sc_core::sc_module (name),
      m_renode_bridge ("m_renode_bridge", renode_address, renode_port),
      m_dbg_test ("m_dbg_test") {
  m_renode_bridge.target_socket (m_dbg_test.bus_initiator_socket);

  m_renode_bridge.gpio_ports_out[1] (dbg_test_begin);
  m_dbg_test.test_begin (dbg_test_begin);
}

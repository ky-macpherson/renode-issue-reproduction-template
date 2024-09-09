#pragma once

#include "tlm.h"

#include "dbg_test.h"
#include "renode_bridge.h"

class top : public sc_core::sc_module {
public:
  top(sc_core::sc_module_name name, const char *address, const char *port);

private:
  renode_bridge m_renode_bridge;
  dbg_test m_dbg_test;

  sc_core::sc_signal<bool> dbg_test_begin;
};

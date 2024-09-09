#include "dbg_test.h"

#include "tlm.h"

#include <cstring>
#include <stdio.h>

SC_HAS_PROCESS(dbg_test);
dbg_test::dbg_test (sc_core::sc_module_name name) {
  SC_THREAD (dbg_test_sequence);

  payload.reset (new tlm::tlm_generic_payload ());
}

static void reset_payload (tlm::tlm_generic_payload &payload) {
  // Reset the TLM payload to reuse it between requests.
  payload.set_command (tlm::TLM_IGNORE_COMMAND);
  payload.set_address (0);
  payload.set_data_ptr (nullptr);
  payload.set_data_length (1);
  payload.set_streaming_width (1);
  payload.set_byte_enable_ptr (nullptr);
  payload.set_byte_enable_length (0);
  payload.set_dmi_allowed (false);
  payload.set_response_status (tlm::TLM_INCOMPLETE_RESPONSE);
}

unsigned char buffer[512];

void dbg_test::dbg_test_sequence() {
  uint32_t write_data_word;
  uint32_t read_data_word = 0;
  uint64_t test_address;
  tlm::tlm_dmi dmi_data;
  while (true) {
    sc_core::wait (test_begin.posedge_event());

    puts ("First test: write via b_transport, read via transport_dbg\n");
    test_address = 0x20001230;
    write_data_word = 0xb1e55ed;

    // Write test value using b_transport
    reset_payload (*payload);
    payload->set_command (tlm::TLM_WRITE_COMMAND);
    payload->set_address (test_address);
    payload->set_data_ptr (reinterpret_cast<unsigned char*>(&write_data_word));
    payload->set_data_length (4);
    payload->set_streaming_width (4);

    sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
    bus_initiator_socket->b_transport (*payload, delay);
    if (payload->get_response_status() != tlm::TLM_OK_RESPONSE) {
      fprintf (stderr, "Failed to write to system bus\n");
      assert (false);
      return;
    }

    // read back the value using transport_dbg
    // reading a 480 bytes memory block that includes the test value
    reset_payload (*payload);
    payload->set_command (tlm::TLM_READ_COMMAND);
    payload->set_address (test_address-288); // base address for the debug xfer
    payload->set_data_ptr (buffer);
    payload->set_data_length (480);
    payload->set_streaming_width (4);

    unsigned int dbg_bytes_xferred = bus_initiator_socket->transport_dbg (*payload);
    if (dbg_bytes_xferred != 480) {
      fprintf (stderr, "transport_dbg() did not succeed\n");
      assert (false);
      return;
    }

    // verify dbg read data
    std::memcpy (&read_data_word, &buffer[288], 4);
    if (read_data_word == write_data_word) {
      puts ("dbg read data matched\n");
    } else {
      fprintf (stderr, "dbg read data mismatched\n");
      assert (false);
      return;
    }
  }
}

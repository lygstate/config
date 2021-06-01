#include <stdlib.h>
#include <ctype.h>

#include <lwip/sio.h>

#include "ringbuf.h"
#define SIO_UART_COUNT 6
#define RING_BUFFER_SIZE 64 * 1024

/*
  0: Virtual AT Serial
  1: COM1
  2: COM3
  3: USBCOM5
  4: USBCOM6
  5: USBCOM7
*/
typedef struct sio_uart {
  struct ringbuf rb;
  uint8_t *buffer;
} sio_uart_t;

sio_fd_t sio_open(u8_t devnum, u32_t baud_rate)
{
  drvUart_t *uart = NULL;
  sio_uart_t *uart_used = uart_list + devnum;
  if (devnum >= SIO_UART_COUNT) {
    return NULL;
  }
  if (uart_used->buffer == NULL) {
    uart_used->buffer = malloc(RING_BUFFER_SIZE);
    ringbuf_init(&uart_used->rb, uart_used->buffer, RING_BUFFER_SIZE);
  }
}


/**
 * Tries to read from the serial device. Same as sio_read but returns
 * immediately if no data is available and never blocks.
 *
 * @param fd serial device handle
 * @param data pointer to data buffer for receiving
 * @param len maximum length (in bytes) of data to receive
 * @return number of bytes actually received
 */
u32_t sio_tryread(sio_fd_t fd, u8_t *data, u32_t len)
{
  sio_uart_t *uart = (sio_uart_t *)fd;

  return ringbuf_read(&(uart->rb), data, len);
}

/**
 * Writes to the serial device.
 *
 * @param fd serial device handle
 * @param data pointer to data to send
 * @param len length (in bytes) of data to send
 * @return number of bytes actually sent
 *
 * @note This function will block until all data can be sent.
 */
u32_t sio_write(sio_fd_t fd, const u8_t *data, u32_t len)
{
  sio_uart_t *uart = (sio_uart_t *)fd;
}


u8_t sio_reconnected(sio_fd_t fd)
{
  return 0;
}

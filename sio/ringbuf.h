
/*
 * Copyright (c) 2018, Angelo Haller
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef RINGBUF_H
#define RINGBUF_H

#include <inttypes.h>
#include <stdbool.h>

#ifdef _MSC_VER
#define _Atomic
#else
#include <stdatomic.h>
#endif

struct ringbuf {
	_Atomic size_t read_idx;
	_Atomic size_t write_idx;
	size_t capacity;
	size_t capacity_mask;
	uint8_t *data;
};
/* From https://github.com/szanni/ringbuf/commits/master */
/*!
 * \brief Allocate a new SPSC ring buffer.
 *
 * Allocate a new single producer, single consumer ring buffer.
 * The capacity will be rounded up to the next power of 2.
 *
 * \param capacity Capacity of the ring buffer.
 * \return A pointer to a newly allocated ring buffer, NULL on error.
 */
bool
ringbuf_init(struct ringbuf *rb, uint8_t *data, size_t capacity);

/*!
 * \brief Reset the ring buffer to the initial state.
 *
 * \param rb Ring buffer instance.
 * \return void
 */
void
ringbuf_reset(struct ringbuf *rb);

/*!
 * \brief Write to ring buffer.
 * \warning Only call this function from a single producer thread.
 *
 * \param rb Ring buffer instance.
 * \param buf Buffer holding data to be written to ring buffer.
 * \param buf_size Buffer size in bytes.
 * \return Number of bytes written to ring buffer.
 */
size_t
ringbuf_write(struct ringbuf *rb, uint8_t *buf, size_t buf_size);

/*!
 * \brief Read from ring buffer.
 * \warning Only call this function from a single consumer thread.
 *
 * \param rb Ring buffer instance.
 * \param buf Buffer to copy data to from ring buffer.
 * \param buf_size Buffer size in bytes.
 * \return Number of bytes read from ring buffer.
 */
size_t
ringbuf_read(struct ringbuf *rb, uint8_t *buf, size_t buf_size);

#endif

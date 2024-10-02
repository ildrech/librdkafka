###Copyright (C) 2024 Ildar Rechapov <ildar.rch@gmail.com>
###This code is public domain and can be freely used or copied.

AUTOMAKE_OPTIONS=subdir-objects
MAINTAINERCLEANFILES = Makefile.in

### librdkafka

lib_LTLIBRARIES = librdkafka.la

librdkafka_la_SOURCES = rdkafka.c rdkafka_broker.c rdkafka_msg.c rdkafka_topic.c \
		rdkafka_conf.c rdkafka_timer.c rdkafka_offset.c \
		rdkafka_transport.c rdkafka_buf.c rdkafka_queue.c rdkafka_op.c \
		rdkafka_request.c rdkafka_cgrp.c rdkafka_pattern.c \
		rdkafka_partition.c rdkafka_subscription.c \
		rdkafka_assignment.c \
		rdkafka_assignor.c rdkafka_range_assignor.c \
		rdkafka_roundrobin_assignor.c rdkafka_sticky_assignor.c \
		rdkafka_feature.c \
		rdcrc32.c crc32c.c rdmurmur2.c rdfnv1a.c cJSON.c \
		rdaddr.c rdrand.c rdlist.c \
		tinycthread.c tinycthread_extra.c \
		rdlog.c rdstring.c rdkafka_event.c rdkafka_metadata.c \
		rdregex.c rdports.c rdkafka_metadata_cache.c rdavl.c \
		rdkafka_sasl.c rdkafka_sasl_plain.c rdkafka_interceptor.c \
		rdkafka_msgset_writer.c rdkafka_msgset_reader.c \
		rdkafka_header.c rdkafka_admin.c rdkafka_aux.c \
		rdkafka_background.c rdkafka_idempotence.c rdkafka_cert.c \
		rdkafka_txnmgr.c rdkafka_coord.c rdbase64.c \
		rdvarint.c rdbuf.c rdmap.c rdunittest.c \
		rdkafka_mock.c rdkafka_mock_handlers.c rdkafka_mock_cgrp.c \
		rdkafka_error.c rdkafka_fetcher.c rdkafka_telemetry.c \
		rdkafka_telemetry_encode.c rdkafka_telemetry_decode.c \
		nanopb/pb_encode.c nanopb/pb_decode.c nanopb/pb_common.c \
		opentelemetry/metrics.pb.c opentelemetry/common.pb.c opentelemetry/resource.pb.c \
        regexp.c \
        rdkafka.h rdkafka_mock.h

librdkafka_la_LDFLAGS = -fPIC -no-undefined -version-info @version_info@ @release_info@

librdkafkapkgincludedir = $(pkgincludedir)-@VMAJ@
librdkafkapkginclude_DATA = $(top_srcdir)/rdkafka.h 

EXTRA_DIST = librdkafka.pc.in

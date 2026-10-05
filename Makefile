
execdirs :=  cnet/gdeliveryd/ cnet/glinkd/ cnet/gamedbd/ cnet/gfaction/ cnet/logservice/ cnet/gacd/  \
				cnet/uniquenamed/

skilldir :=   cskill/skill/
build_targets := libperf subs subsskill libs gs

all: $(build_targets)
build: $(build_targets)
clean: clean-libperf clean-subs clean-subsskill  clean-libs clean-gs

makegs: libperf subsskill libs gs
cleangs: clean-libperf clean-subsskill clean-libs clean-gs

makecnet: libperf subs
cleancnet: clean-libperf clean-subs

configure: setrules configure-shared configure-iolib
clean-configure: clean-shared clean-iolib

libs: libcommon libgs
clean-libs: clean-libgs clean-libcommon 

install: build
	#strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cgame/gs/gs; \
	cp ./cgame/gs/gs /home/gamed; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cgame/gs/libtask.so; \
	cp ./cgame/gs/libtask.so /home/gamed; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/gfaction/gfactiond; \
	cp ./cnet/gfaction/gfactiond /home/gfactiond; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/uniquenamed/uniquenamed; \
	cp ./cnet/uniquenamed/uniquenamed /home/uniquenamed; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/gamedbd/gamedbd; \
	cp ./cnet/gamedbd/gamedbd /home/gamedbd; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/gdeliveryd/gdeliveryd; \
	cp ./cnet/gdeliveryd/gdeliveryd /home/gdeliveryd; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/glinkd/glinkd; \
	cp ./cnet/glinkd/glinkd /home/glinkd; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/gacd/gacd; \
	cp ./cnet/gacd/gacd /home/gacd; \
	strip -g -S -d --strip-debug --strip-unneeded --keep-file-symbols ./cnet/logservice/logservice; \
	cp ./cnet/logservice/logservice /home/logservice;

libperf:
	$(MAKE) -C cnet/perf

clean-libperf:
	cd cnet/perf; \
	make clean;  \
	cd ../../

libcommon:
	$(MAKE) -j8 -C cgame/libcommon

clean-libcommon:
	cd cgame/libcommon; \
	make clean;  \
	cd ../../

libgs: libLogClient libgsio  libgsPro2 libdbCli
	mkdir -p cgame/libgs/io cgame/libgs/gs cgame/libgs/db cgame/libgs/sk cgame/libgs/log
	$(MAKE) -C cgame/libgs

clean-libgs: clean-libgsio clean-libLogClient clean-libgsPro2 clean-libdbCli
	cd cgame/libgs; \
	make clean; \
	cd ../../

gs:
	$(MAKE) -C cgame clean
	$(MAKE) -j8 -C cgame
	
clean-gs:
	cd cgame; \
	make clean; \
	cd ..;

.PHONY: rpcgen

setrules:
	bash ./setrules.sh;
	

configure-shared:
	@set -eu; \
	cd cnet; \
	for name in common io perf mk storage rpc; do \
		if [ -e "$$name" ] && [ ! -L "$$name" ]; then \
			echo "ERROR: cnet/$$name exists and is not a symlink; refusing to replace it."; \
			exit 1; \
		fi; \
		ln -sfn "../share/$$name" "$$name"; \
	done

configure-iolib:
	@set -eu; \
	mkdir -p iolib/inc; \
	find iolib/inc -mindepth 1 -maxdepth 1 -type l -delete; \
	find iolib -mindepth 1 -maxdepth 1 -type l -name 'lib*' -delete; \
	link() { \
		if [ -e "$$2" ] && [ ! -L "$$2" ]; then \
			echo "ERROR: $$2 exists and is not a symlink; refusing to replace it."; \
			exit 1; \
		fi; \
		ln -sfn "$$1" "$$2"; \
	}; \
	link ../../cnet/gamed/auctionsyslib.h iolib/inc/auctionsyslib.h; \
	link ../../cnet/gamed/sysauctionlib.h iolib/inc/sysauctionlib.h; \
	link ../../cnet/gdbclient/db_if.h iolib/inc/db_if.h; \
	link ../../cnet/gamed/factionlib.h iolib/inc/factionlib.h; \
	link ../../cnet/common/glog.h iolib/inc/glog.h; \
	link ../../cnet/gamed/gsp_if.h iolib/inc/gsp_if.h; \
	link ../../cnet/gamed/mailsyslib.h iolib/inc/mailsyslib.h; \
	link ../../cnet/gamed/privilege.hxx iolib/inc/privilege.hxx; \
	link ../../cnet/gamed/sellpointlib.h iolib/inc/sellpointlib.h; \
	link ../../cnet/gamed/stocklib.h iolib/inc/stocklib.h; \
	link ../../cnet/gamed/webtradesyslib.h iolib/inc/webtradesyslib.h; \
	link ../../cnet/gamed/kingelectionsyslib.h iolib/inc/kingelectionsyslib.h; \
	link ../../cnet/gamed/pshopsyslib.h iolib/inc/pshopsyslib.h; \
	link ../cnet/io/libgsio.a iolib/libgsio.a; \
	link ../cnet/gdbclient/libdbCli.a iolib/libdbCli.a; \
	link ../cnet/gamed/libgsPro2.a iolib/libgsPro2.a; \
	link ../cnet/logclient/liblogCli.a iolib/liblogCli.a; \
	link ../cskill/skill/libskill.a iolib/libskill.a

rpcgen:
	cd cnet; \
	sh ./rpcgen rpcalls.xml; \
	cd gfaction/operations; \
	perl ./opgen.pl; \
	cd ../../..; 

subsskill:
	@set -eu; \
	for dir in $(skilldir); do \
        $(MAKE) -C $$dir clean; \
        $(MAKE) -j8 -C $$dir; \
    done

clean-subsskill:
	for dir in $(skilldir); do \
        $(MAKE) -C $$dir clean; \
    done


subs:
	@set -eu; \
	for dir in $(execdirs); do \
        $(MAKE) -C $$dir clean; \
        $(MAKE) -j8 -C $$dir; \
    done

clean-subs:
	for dir in $(execdirs); do \
        $(MAKE) -C $$dir clean; \
    done

libshared-common:
	$(MAKE) -C cnet/common octets.o thread.o conf.o timer.o itimer.o

libgsio: libperf libshared-common
	$(MAKE) -C cnet/io lib

clean-libgsio:
	cd cnet/io; \
	rm -f libgsio.a; \
	cd ../..;

libLogClient:
	cd cnet/logclient; \
	make clean; \
	make -f Makefile.gs -j8; \
	cd ../..;
	
clean-libLogClient:
	cd cnet/logclient; \
	rm -f liblogCli.a; \
	cd ../..;

libgsPro2:
	cd cnet/gamed; \
	make clean; \
	make lib -j8; \
	cd ../..;
	
clean-libgsPro2:
	cd cnet/gamed; \
	make clean; \
	cd ../..;

libdbCli:
	cd cnet/gdbclient; \
	make clean; \
	make lib -j8; \
	cd ../..;
	
clean-libdbCli:
	cd cnet/gdbclient; \
	make clean; \
	cd ../..;

clean-shared:
	@set -eu; \
	for name in common io perf mk storage rpc; do \
		if [ -L "cnet/$$name" ]; then rm -f "cnet/$$name"; \
		elif [ -e "cnet/$$name" ]; then \
			echo "ERROR: cnet/$$name is not a symlink; refusing to remove it."; \
			exit 1; \
		fi; \
	done

clean-iolib:
	@set -eu; \
	if [ -d iolib/inc ]; then find iolib/inc -mindepth 1 -maxdepth 1 -type l -delete; fi; \
	if [ -d iolib ]; then find iolib -mindepth 1 -maxdepth 1 -type l -name 'lib*' -delete; fi

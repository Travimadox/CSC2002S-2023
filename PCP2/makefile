JAVAC=/usr/bin/javac
JAVADOC=/usr/bin/javadoc
.SUFFIXES: .java .class
SRCDIR=./src/clubSimulation
BINDIR=./bin/clubSimulation
BINDIRCLEAN=./bin/clubSimulation/clubSimulation

DOCDIR=doc
ARGS=""

default:
	$(JAVAC) -d $(BINDIR)/ -cp $(BINDIR):$(SRCDIR) $(SRCDIR)/*.java

clean:
	rm $(BINDIRCLEAN)/*.class
run: default
	java -cp ./bin/clubSimulation clubSimulation.ClubSimulation $(ARGS)

javadoc:
	$(JAVADOC) -d $(DOCDIR) -sourcepath $(SRCDIR) -classpath $(BINDIR) $(SRCDIR)/*.java

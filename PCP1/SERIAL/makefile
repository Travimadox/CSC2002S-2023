JAVAC=/usr/bin/javac
JAVADOC=/usr/bin/javadoc
.SUFFIXES: .java .class
SRCDIR=./src/MonteCarloMini
BINDIR=./bin
BINDIRCLEAN=./bin/MonteCarloMini
DOCDIR=doc
ARGS=""

default:
	$(JAVAC) -d $(BINDIR)/ -cp $(BINDIR):$(SRCDIR) $(SRCDIR)/*.java

clean:
	rm $(BINDIRCLEAN)/*.class
run: default
	java -cp ./bin/MonteCarloMini MonteCarloMini.MonteCarloMinimization $(ARGS)

javadoc:
	$(JAVADOC) -d $(DOCDIR) -sourcepath $(SRCDIR) -classpath $(BINDIR) $(SRCDIR)/*.java

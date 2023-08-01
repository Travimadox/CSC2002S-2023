JAVAC=/usr/bin/javac
JAVADOC=/usr/bin/javadoc 
.SUFFIXES: .java .class
SRCDIR=./src/MonteCarloMini
BINDIR=./bin/MonteCarloMini
DOCDIR=doc

$(BINDIR)/%.class: $(SRCDIR)/%.java
	$(JAVAC) -d $(BINDIR)/ -cp $(BINDIR):$(SRCDIR) $<
	
CLASSES= Search.class TerrainArea.class MonteCarloMinimization.class 
CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

default: $(CLASS_FILES)
clean:
	rm $(BINDIR)/*.class
run: $(CLASS_FILES)
	java -cp ./bin MonteCarloMini.MonteCarloMinimization
	
javadoc:
	$(JAVADOC) -d $(DOCDIR) -sourcepath $(SRCDIR) -classpath $(BINDIR) $(SRCDIR)/*.java
PYTHON_PARSERS = RigolWFM/wfm1000c.py RigolWFM/wfm1000e.py RigolWFM/wfm1000z.py \
                 RigolWFM/wfm2000.py RigolWFM/wfm4000.py RigolWFM/wfm6000.py

KSC ?= kaitai-struct-compiler

KSY_OPTIONS = --verbose=all --outdir RigolWFM
KSY_OPTIONS = --outdir RigolWFM

KSY_PYTHON_OPTIONS = -t python $(KSY_OPTIONS)
KSY_C_OPTIONS = -t cpp_stl --cpp-standard 11  $(KSY_OPTIONS)

YAML_LINT_OPTIONS = -d "{extends: default, rules: {document-start: disable}}"

SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = docs
BUILDDIR      = docs/_build

export PYTHONPATH ?= .

all: $(PYTHON_PARSERS)

RigolWFM/wfm1000c.py: ksy/wfm1000c.ksy
	$(KSC) $(KSY_PYTHON_OPTIONS) $<

RigolWFM/wfm1000e.py: ksy/wfm1000e.ksy
	$(KSC) $(KSY_PYTHON_OPTIONS) $<

RigolWFM/wfm1000z.py: ksy/wfm1000z.ksy
	$(KSC) $(KSY_PYTHON_OPTIONS) $<

RigolWFM/wfm2000.py: ksy/wfm2000.ksy
	$(KSC) $(KSY_PYTHON_OPTIONS) $<

RigolWFM/wfm4000.py: ksy/wfm4000.ksy
	$(KSC) $(KSY_PYTHON_OPTIONS) $<

RigolWFM/wfm6000.py: ksy/wfm6000.ksy
	$(KSC) $(KSY_PYTHON_OPTIONS) $<

yamlcheck:
	-yamllint $(YAML_LINT_OPTIONS) ksy/wfm1000c.ksy
	-yamllint $(YAML_LINT_OPTIONS) ksy/wfm1000e.ksy
	-yamllint $(YAML_LINT_OPTIONS) ksy/wfm1000z.ksy
	-yamllint $(YAML_LINT_OPTIONS) ksy/wfm2000.ksy
	-yamllint $(YAML_LINT_OPTIONS) ksy/wfm4000.ksy
	-yamllint $(YAML_LINT_OPTIONS) ksy/wfm6000.ksy

ksycheck:
	-ksylint ksy/wfm1000c.ksy
	-ksylint ksy/wfm1000e.ksy
	-ksylint ksy/wfm1000z.ksy
	-ksylint ksy/wfm2000.ksy
	-ksylint ksy/wfm4000.ksy
	-ksylint ksy/wfm6000.ksy

check:
	make yamlcheck
	make ksycheck
	-pylint RigolWFM/wfm.py
	-pep257 RigolWFM/wfm.py
	-pylint RigolWFM/channel.py
	-pep257 RigolWFM/channel.py
	-pylint RigolWFM/wfmconvert.py
	-pep257 RigolWFM/wfmconvert.py

html:
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)

teste:
	python3 RigolWFM/wfmconvert.py E info wfm/DS1102E-A.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1102E-B.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1102E-C.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1102E-D.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1052E.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1000E-A.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1000E-B.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1000E-C.wfm
	python3 RigolWFM/wfmconvert.py E info wfm/DS1000E-D.wfm

testz:
	python3 RigolWFM/wfmconvert.py Z info wfm/DS1054Z-A.wfm
	python3 RigolWFM/wfmconvert.py Z info wfm/MSO1104.wfm
	python3 RigolWFM/wfmconvert.py Z info wfm/DS1074Z-A.wfm
	python3 RigolWFM/wfmconvert.py Z info wfm/DS1074Z-B.wfm

test2:
	python3 RigolWFM/wfmconvert.py 2 info wfm/DS2000-A.wfm
	python3 RigolWFM/wfmconvert.py 2 info wfm/DS2000-B.wfm

test4:
	python3 RigolWFM/wfmconvert.py 4 info wfm/DS4022-A.wfm
	python3 RigolWFM/wfmconvert.py 4 info wfm/DS4022-B.wfm
	python3 RigolWFM/wfmconvert.py 4 info wfm/DS4024-A.wfm
	python3 RigolWFM/wfmconvert.py 4 info wfm/DS4024-B.wfm

test: $(PYTHON_PARSERS)
	make teste
	make testz
	make test4
	make test2
	make csv
	make wav

csv:
	python3 RigolWFM/wfmconvert.py E csv wfm/DS1102E-A.wfm
	python3 RigolWFM/wfmconvert.py Z csv wfm/MSO1104.wfm
	python3 RigolWFM/wfmconvert.py 4 csv wfm/DS4022-A.wfm

wav:
	python3 RigolWFM/wfmconvert.py E wav wfm/DS1102E-A.wfm
	python3 RigolWFM/wfmconvert.py Z wav wfm/MSO1104.wfm
	python3 RigolWFM/wfmconvert.py 4 wav wfm/DS4022-A.wfm
	
clean:
	rm -rf dist
	rm -rf RigolWFM.egg-info
	rm -rf docs/github.com
	rm -rf RigolWFM/__pycache__
	rm -rf wfm/DS1102E-A.csv
	rm -rf wfm/MSO1104.csv
	rm -rf wfm/DS4022-A.csv
	rm -rf wfm/DS1102E-A.wav
	rm -rf wfm/MSO1104.wav
	rm -rf wfm/DS4022-A.wav
	rm -rf docs/_build/*
	rm -rf docs/api/*
	rm -rf .tox

realclean:
	make clean
	rm -f RigolWFM/wfm1000c.py 
	rm -f RigolWFM/wfm1000e.py 
	rm -f RigolWFM/wfm1000z.py 
	rm -f RigolWFM/wfm2000.py
	rm -f RigolWFM/wfm4000.py
	rm -f RigolWFM/wfm6000.py

	
.PHONY: clean realclean test check all ksycheck yamlcheck teste testz test4 test csv wav help
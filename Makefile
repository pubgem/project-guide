# Ian Dennis Miller
# project-management skeleton makefile

PROJECT_NAME=pubgem

OUT_DIR=output
SRC_DIR=docs

# When compiling final project documentation, this is the order for combining sub-documents
define DOCUMENT_ORDER
$(SRC_DIR)/planning/$(PROJECT_NAME)_Charter.md \
$(SRC_DIR)/planning/$(PROJECT_NAME)_Scope.md \
$(SRC_DIR)/design/$(PROJECT_NAME)_Design.md \
$(SRC_DIR)/spec/$(PROJECT_NAME)_Data_Model_Specification.md \
$(SRC_DIR)/spec/$(PROJECT_NAME)_Functional_Specification.md \
$(SRC_DIR)/spec/$(PROJECT_NAME)_Technical_Specification.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Requirements.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Tests_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Risks_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Hazards_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Mitigations_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Security.md \
$(SRC_DIR)/operation/$(PROJECT_NAME)_Installation.md \
$(SRC_DIR)/operation/$(PROJECT_NAME)_Upgrading.md \
$(SRC_DIR)/usage/$(PROJECT_NAME)_Admin_Guide.md \
$(SRC_DIR)/usage/$(PROJECT_NAME)_User_Guide.md \
$(SRC_DIR)/planning/Agile_Management_Plan.md
endef

# When compiling final project documentation, this is the order of attachments
define ASSET_ORDER
$(OUT_DIR)/planning/$(PROJECT_NAME)_Organization_View.pdf \
$(OUT_DIR)/planning/$(PROJECT_NAME)_Team_Resources_Diagram.pdf \
$(OUT_DIR)/planning/$(PROJECT_NAME)_Timeline.pdf \
$(OUT_DIR)/design/$(PROJECT_NAME)_Entity_Relationship_Diagram.pdf \
$(OUT_DIR)/design/$(PROJECT_NAME)_Process_Map.pdf \
$(OUT_DIR)/design/$(PROJECT_NAME)_Site_Map.pdf \
$(OUT_DIR)/design/$(PROJECT_NAME)_System_Map.pdf \
$(OUT_DIR)/design/$(PROJECT_NAME)_Architecture.pdf \
$(OUT_DIR)/design/$(PROJECT_NAME)_Wireframes.pdf
endef

# These are the documents that should be rendered as presentations
define PRESENTATIONS
$(PROJECT_NAME)_Project_Guide_Presentation.pdf \
planning/$(PROJECT_NAME)_Charter_Presentation.pdf \
planning/$(PROJECT_NAME)_Scope_Presentation.pdf \
design/$(PROJECT_NAME)_Design_Presentation.pdf \
planning/Agile_Management_Plan_Presentation.pdf
endef

# These are the source compliance documents
define COMPLIANCE_SOURCES
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Requirements.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Tests_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Risks_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Hazards_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Mitigations_Register.md \
$(SRC_DIR)/compliance/$(PROJECT_NAME)_Security.md
endef

define COMPLIANCE_TARGETS
$(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.html \
$(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.docx \
$(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.pdf
endef

define WWW_FILES
$(OUT_DIR)/index.html \
$(OUT_DIR)/unimplemented.html
endef

SUBDIRS=planning operation compliance design itops spec usage
SUBDIR_TARGETS=$(addprefix $(OUT_DIR)/,$(SUBDIRS))

EXTRA_FILES=$(COMPLIANCE_TARGETS) $(WWW_FILES)
PROJECT_TARGETS=$(OUT_DIR)/$(PROJECT_NAME)_Project.pdf $(OUT_DIR)/$(PROJECT_NAME)_Project.docx
PRESENTATION_TARGETS=$(addprefix $(OUT_DIR)/,$(PRESENTATIONS))

MD=$(subst $(SRC_DIR)/,,$(wildcard $(SRC_DIR)/**/*.md)) $(PROJECT_NAME)_Project_Guide.md
HTML=$(addprefix $(OUT_DIR)/,$(MD:.md=.html))
PDF=$(addprefix $(OUT_DIR)/,$(MD:.md=.pdf))
DOCX=$(addprefix $(OUT_DIR)/,$(MD:.md=.docx))
DOC_TARGETS=$(HTML) $(DOCX) $(PDF) $(EXTRA_FILES)

GRAFFLE=$(subst $(SRC_DIR)/,,$(wildcard $(SRC_DIR)/**/*.graffle))
GRAFFLE_ZIP=$(addprefix $(OUT_DIR)/,$(GRAFFLE:.graffle=.zip))
GRAFFLE_PDF=$(addprefix $(OUT_DIR)/,$(GRAFFLE:.graffle=.pdf))
GRAFFLE_PNG=$(addprefix $(OUT_DIR)/,$(GRAFFLE:.graffle=.png))
GRAFFLE_TARGETS=$(GRAFFLE_PDF) $(GRAFFLE_PNG) $(GRAFFLE_ZIP)

OPLX=$(subst $(SRC_DIR)/,,$(wildcard $(SRC_DIR)/**/*.oplx))
OPLX_ZIP=$(addprefix $(OUT_DIR)/,$(OPLX:.oplx=.zip))
OPLX_PDF=$(addprefix $(OUT_DIR)/,$(OPLX:.oplx=.pdf))
OPLX_PNG=$(addprefix $(OUT_DIR)/,$(OPLX:.oplx=.png))
OPLX_TARGETS=$(OPLX_PDF) $(OPLX_PNG) $(OPLX_ZIP)

OO3=$(subst $(SRC_DIR)/,,$(wildcard $(SRC_DIR)/**/*.oo3))
OO3_ZIP=$(addprefix $(OUT_DIR)/,$(OO3:.oo3=.zip))
#OO3_PDF=$(addprefix $(OUT_DIR)/,$(OO3:.oo3=.pdf))
#OO3_PNG=$(addprefix $(OUT_DIR)/,$(OO3:.oo3=.png))
OO3_TARGETS=$(OO3_ZIP) $(OO3_PDF) $(OO3_PNG)

all: $(SUBDIR_TARGETS) $(OO3_TARGETS) $(OPLX_TARGETS) $(GRAFFLE_TARGETS) $(DOC_TARGETS) $(PRESENTATION_TARGETS)
	-cp -r assets/iso output
	@echo done

project: all $(PROJECT_TARGETS)
	@echo done

# Markdown -> PDF
$(OUT_DIR)/%.pdf: $(SRC_DIR)/%.md
	@echo compiling $< as PDF
	pandoc -f markdown -t latex --toc $< -o $@

# Markdown -> DOCX
$(OUT_DIR)/%.docx: $(SRC_DIR)/%.md
	@echo compiling $< as DOCX
	pandoc -f markdown -t docx --reference-docx=assets/docx/reference.docx --toc $< -o $@

# Markdown -> HTML
$(OUT_DIR)/%.html: $(SRC_DIR)/%.md
	@echo compiling $< as HTML
	pandoc -f markdown -t html --toc --template assets/www/template.html \
		-c assets/www/ryangray-style.css -c assets/www/style.css -s --self-contained $< -o $@

# Markdown -> PDF Presentation
$(OUT_DIR)/%_Presentation.pdf: $(SRC_DIR)/%.md
	@echo compiling $< as PDF presentation
	pandoc -f markdown -t beamer -V theme:Warsaw $< -o $@

# OmniGraffle -> ZIP
$(OUT_DIR)/%.zip: $(SRC_DIR)/%.graffle
	@echo compressing $< as ZIP
	zip -r $@ $<

# OmniPlan -> ZIP
$(OUT_DIR)/%.zip: $(SRC_DIR)/%.oplx
	@echo compressing $< as ZIP
	zip -r $@ $<

# OmniOutliner -> ZIP
$(OUT_DIR)/%.zip: $(SRC_DIR)/%.oo3
	@echo compressing $< as ZIP
	zip -r $@ $<

# OmniOutliner -> PDF
$(OUT_DIR)/%.pdf: $(SRC_DIR)/%.oo3
	@echo rendering $< as PDF
	osascript $$PWD/assets/script/omnioutliner-export.applescript \
		"$$PWD/$<" /tmp/outliner.rtf "public.rtf" && \
		textutil -convert docx /tmp/outliner.rtf -output /tmp/outliner.docx && \
		pandoc --latex-engine=xelatex -o /tmp/outliner.pdf /tmp/outliner.docx && \
		mv /tmp/outliner.pdf "$(OUT_DIR)/planning/$(PROJECT_NAME) Checklist.pdf"

# OmniOutliner -> DOCX
$(OUT_DIR)/%.docx: $(SRC_DIR)/%.oo3
	@echo rendering $< as DOCX
	osascript $$PWD/assets/script/omnioutliner-export.applescript \
		"$$PWD/$<" /tmp/outliner.rtf "public.rtf" && \
		textutil -convert docx /tmp/outliner.rtf -output /tmp/outliner.docx && \
		mv /tmp/outliner.docx $@

# OmniGraffle -> PDF
$(OUT_DIR)/%.pdf: $(SRC_DIR)/%.graffle
	@echo rendering $< as PDF
	osascript $$PWD/assets/script/omnigraffle-export.applescript \
		"$$PWD/$<" /tmp/graffle.pdf pdf && mv /tmp/graffle.pdf $@

# OmniGraffle, OmniPlan PDFs -> PNG
$(OUT_DIR)/%.png: $(OUT_DIR)/%.pdf
	@echo converting $< to PNG
	convert $< $@ && touch $@

# OmniPlan -> PDF
$(OUT_DIR)/%.pdf: $(SRC_DIR)/%.oplx
	@echo rendering $< as PDF
	osascript $$PWD/assets/script/omniplan-export.applescript \
		"$$PWD/$<" /tmp/plan.pdf PDF && mv /tmp/plan.pdf $@

# Compile the complete project PDF
$(OUT_DIR)/$(PROJECT_NAME)_Project.pdf:
	@echo Compile the complete project as PDF $@

	# combine project documentation
	pandoc -f markdown -t latex --toc -o /tmp/project.pdf $(DOCUMENT_ORDER)

	# combine project assets
	pdfjam --landscape -o /tmp/assets.pdf $(ASSET_ORDER)

	# make a single document
	pdfjam --rotateoversize true -o $@ /tmp/project.pdf /tmp/assets.pdf

	# clean up
	rm /tmp/project.pdf /tmp/assets.pdf

# Compile the complete project DOCX
$(OUT_DIR)/$(PROJECT_NAME)_Project.docx:
	@echo Compile the complete project as DOCX $@
	pandoc -f markdown -t docx --reference-docx=assets/docx/reference.docx --toc -o $@ $(DOCUMENT_ORDER)

# Compile the compliance document
$(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.html: $(COMPLIANCE_SOURCES)
	@echo Compile the compliance document $@

	cat $(COMPLIANCE_SOURCES) > /tmp/step1.md

	assets/script/amalgamate.pl /tmp/step1.md > /tmp/compliance.md

	pandoc -f markdown -t html --chapters --toc --template assets/www/template.html \
		-c assets/www/ryangray-style.css -c assets/www/style.css -s --self-contained $(SRC_DIR)/compliance/$(PROJECT_NAME)_Compliance_Header.md /tmp/compliance.md -o $@

# Compile the compliance document
$(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.docx: $(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.html
	@echo Compile the compliance document as DOCX $@
	pandoc -f html -t docx $< -o $@

# Compile the compliance document
$(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.pdf: $(OUT_DIR)/compliance/$(PROJECT_NAME)_Compliance_Report.html
	@echo Compile the compliance document as PDF $@
	pandoc -f html -t latex --latex-engine=xelatex $< -o $@

# Copy a web file
$(OUT_DIR)/%.html: assets/www/%.html
	@echo copy web file: $<
	cp -v $< $@

# create output directories
$(SUBDIR_TARGETS):
	@echo create directory $@
	mkdir -p $@

clean:
	rm -rf output

rsync:
	rsync -a --delete output/ idmiller_project-pubgem@ssh.phx.nearlyfreespeech.net:

.PHONY: all project clean

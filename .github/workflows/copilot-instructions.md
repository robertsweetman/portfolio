---
applyTo: "mdbook/src/project_*.md"
---
# Instructions for creating portfolio project content
- See each local file path (below) for content to populate a project_?.md page
- Fetch the COMPLETE, VERBATIM raw markdown content from the source
- Map the source content to each section heading based on the learning outcome code (K12, S11, etc.) and description in that heading
- ONLY INCLUDE CONTENT FROM THE SOURCE MATERIAL PROVIDED. DO NOT ADD ANY ADDITIONAL INFORMATION OR CONTEXT
- If source content could fit multiple sections, prioritize the most specific/relevant section first
- If there is no relevant content for a section, leave the heading followed by two blank lines
- Preserve the ## Context section unless source material provides a better replacement
- Where possible, make sure there is a picture taken from the source material for each evidence section
- The goal is to provide evidence for each learning outcome using content directly from the source material

# Portfolio Source local file paths
- /Users/robert.sweetman/Documents/Git/module_3 # Local path for project 1 source content
- /Users/robert.sweetman/Documents/Git/module_4 # Local path for project 2 source content
- /Users/robert.sweetman/Documents/Git/data-strategy-presentation # Local path for project 3 source content
- /Users/robert.sweetman/Documents/Git/module_2 # Local path for project 4 source content
- /Users/robert.sweetman/Documents/Git/module_5 # Local path for module 5 source content
- /Users/robert.sweetman/Documents/Git/module_6 # Local path for module 6 source content
- /Users/robert.sweetman/Documents/Git/module_7 # Local path for module 7 source content

## Critical Content Requirements
- **REPRODUCE SOURCE CONTENT FAITHFULLY** - Do not paraphrase, summarize, or rewrite
- **INCLUDE ALL MERMAID DIAGRAMS** - Copy complete ```mermaid code blocks verbatim from source
- **INCLUDE ALL TABLES** - Copy complete markdown tables verbatim with all rows and columns
- **PRESERVE ALL QUOTED TEXT** - Keep italicized quotes and citations exactly as they appear
- **MAINTAIN COMPLETE BULLET LISTS** - Include all bullet points and sub-bullets from source
- **COPY CODE BLOCKS EXACTLY** - Preserve formatting, whitespace, and syntax

## Content Formatting
- Maintain the exact markdown format (headings, lists, images, code blocks, tables) from the source
- All content under ### Evidence must use heading level #### or lower to preserve document hierarchy
- Preserve the original heading structure within each evidence section
- Keep original emphasis (bold, italic, code formatting) intact
- Preserve line breaks and paragraph spacing from source

## Image Handling
- Download images from source material and save to mdbook/src/images/project_?/ (matching the project number)
- Use correct relative paths in markdown: `./images/project_?/image-name.ext`
- Include image references with proper alt text from source

## Quality Check
Before completing, verify:
- [ ] All mermaid diagrams from source are included
- [ ] All tables from source are included with complete data
- [ ] All quoted text is preserved verbatim
- [ ] Content is substantial (400+ lines for comprehensive sources)
- [ ] No paraphrasing or summarization has occurred
- [ ] All images from source are included with correct relative paths and alt text
- [ ] All evidence sections have corresponding images where applicable
- [ ] All content is properly linked to the corresponding local file paths
- [ ] Ideally the evidence should support at LEAST a 'B' grade for each learning outcome

# Follow up file
- Where Evidence of learning is particularly weak, or even missing create a 'follow up' file that calls these sections out explicitly
- Where there's no possibility to add an image to a section, also add this note explicitly in the follow up file
- The follow up file should clearly indicate which sections need additional evidence or images
- the follow up file should also call out any sections that might not achieve a 'B'
- do NOT add content yourself that is not directly available from the source material

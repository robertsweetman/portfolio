---
applyTo: "mdbook/src/project_*.md"
---
# Instructions for creating portfolio project content
- You'll be given a source URL (often a GitHub repository) for content to populate a project_?.md page
- Use agent mode or github_repo tool to fetch the COMPLETE, VERBATIM raw markdown content from the source
- Map the source content to each section heading based on the learning outcome code (K12, S11, etc.) and description in that heading
- ONLY INCLUDE CONTENT FROM THE SOURCE MATERIAL PROVIDED. DO NOT ADD ANY ADDITIONAL INFORMATION OR CONTEXT
- If source content could fit multiple sections, prioritize the most specific/relevant section first
- If there is no relevant content for a section, leave the heading followed by two blank lines
- Preserve the ## Context section unless source material provides a better replacement

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
- [ ] Original markdown formatting is maintained



---
applyTo: "mdbook/src/project_*.md"
---
# Instructions for creating portfolio project content
- You'll be given a source URL for content to populate a project_?.md page
- Map the source content to each section heading based on the learning outcome code (K12, S11, etc.) and description in that heading
- ONLY INCLUDE CONTENT FROM THE SOURCE MATERIAL PROVIDED. DO NOT ADD ANY ADDITIONAL INFORMATION OR CONTEXT
- If source content could fit multiple sections, prioritize the most specific/relevant section first
- If there is no relevant content for a section, leave the heading followed by two blank lines
- Create the ## Context section unless source material provides a better replacement. 

## Content Formatting
- Maintain the relative markdown format (headings, lists, images, code blocks) from the source
- All content headings must be at heading level #### or lower to preserve document hierarchy under the ### Evidence heading

## Image Handling
- Extract images from source material and add them to mdbook/src/images/project_?/ (matching the project number)
- Use correct relative paths: `./images/project_?/image-name.ext`
- Update image references in the markdown to use the new relative paths



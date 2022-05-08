local status_ok, react_extract = pcall(require, "react-extract")
if not status_ok then
	return
end

react_extract.setup({
	ts_type_property_template = "[INDENT][PROPERTY]: any\n",
	ts_template_before = 'import type {FC} from "react";\n'
		.. "type [COMPONENT_NAME]Props = {\n[TYPE_PROPERTIES]}\n[EMPTY_LINE]\n"
		.. "const [COMPONENT_NAME]: FC<[COMPONENT_NAME]Props> = "
		.. "([PROPERTIES]) => {\n"
		.. "[INDENT]return (\n",
	ts_template_after = "[INDENT])\n};\n" .. "export default [COMPONENT_NAME];",
	js_template_before = "export const [COMPONENT_NAME] = " .. "([PROPERTIES]) => {\n" .. "[INDENT]return (\n",
	js_template_after = "[INDENT])\n}",
	use_autoimport = true,
	autoimport_defer_ms = 350,
})

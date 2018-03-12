package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_set_propertiesContext;

public class Field_set_propertiesContextExt extends AbstractBaseExt {

	public Field_set_propertiesContextExt(Field_set_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_set_propertiesContext getContext() {
		return (Field_set_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_set_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_set_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Field_set_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

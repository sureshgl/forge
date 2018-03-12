package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_log_propertiesContext;

public class Type_log_propertiesContextExt extends AbstractBaseExt {

	public Type_log_propertiesContextExt(Type_log_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_log_propertiesContext getContext() {
		return (Type_log_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_log_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_log_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_log_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

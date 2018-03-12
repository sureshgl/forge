package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Register_propertiesContext;

public class Register_propertiesContextExt extends AbstractBaseExt {

	public Register_propertiesContextExt(Register_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Register_propertiesContext getContext() {
		return (Register_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).register_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Register_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Register_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Port_prefix_identifierContext;

public class Port_prefix_identifierContextExt extends AbstractBaseExt {

	public Port_prefix_identifierContextExt(Port_prefix_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_prefix_identifierContext getContext() {
		return (Port_prefix_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_prefix_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_prefix_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Port_prefix_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

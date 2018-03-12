package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Parameter_identifierContext;

public class Parameter_identifierContextExt extends AbstractBaseExt {

	public Parameter_identifierContextExt(Parameter_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parameter_identifierContext getContext() {
		return (Parameter_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parameter_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parameter_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

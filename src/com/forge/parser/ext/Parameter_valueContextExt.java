package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Parameter_valueContext;

public class Parameter_valueContextExt extends AbstractBaseExt {

	public Parameter_valueContextExt(Parameter_valueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parameter_valueContext getContext() {
		return (Parameter_valueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter_value());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parameter_valueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parameter_valueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Slave_typeContext;

public class Slave_typeContextExt extends AbstractBaseExt {

	public Slave_typeContextExt(Slave_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Slave_typeContext getContext() {
		return (Slave_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).slave_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Slave_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Slave_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}

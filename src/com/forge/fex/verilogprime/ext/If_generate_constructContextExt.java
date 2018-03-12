package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.If_generate_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class If_generate_constructContextExt extends AbstractBaseExt {

	public If_generate_constructContextExt(If_generate_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public If_generate_constructContext getContext() {
		return (If_generate_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).if_generate_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof If_generate_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ If_generate_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
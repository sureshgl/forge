package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Simple_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Simple_identifierContextExt extends AbstractBaseExt {

	public Simple_identifierContextExt(Simple_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Simple_identifierContext getContext() {
		return (Simple_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).simple_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Simple_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Simple_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
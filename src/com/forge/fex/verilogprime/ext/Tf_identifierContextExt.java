package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tf_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tf_identifierContextExt extends AbstractBaseExt {

	public Tf_identifierContextExt(Tf_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tf_identifierContext getContext() {
		return (Tf_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tf_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tf_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tf_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
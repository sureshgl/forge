package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Hierarchical_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Hierarchical_instanceContextExt extends AbstractBaseExt {

	public Hierarchical_instanceContextExt(Hierarchical_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hierarchical_instanceContext getContext() {
		return (Hierarchical_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hierarchical_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hierarchical_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hierarchical_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Covergroup_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Covergroup_declarationContextExt extends AbstractBaseExt {

	public Covergroup_declarationContextExt(Covergroup_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Covergroup_declarationContext getContext() {
		return (Covergroup_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).covergroup_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Covergroup_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Covergroup_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}